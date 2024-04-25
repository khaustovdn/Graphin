/* chart-item.vala
 *
 * Copyright 2024 khaustovdn
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Graphin {
    public class ChartItem : Gtk.DrawingArea {
        private Point center { get; set; }
        private double scale { get; set; }

        public ChartItem () {
            Object ();
        }

        construct {
            center = new Point (0.0, 0.0);
            scale = 1.0;

            this.set_content_width (360);
            this.set_content_height (480);
            this.set_draw_func (draw);

            Point current_position = this.center;
            double current_scale = this.scale;

            Gtk.GestureDrag move_gesture = new Gtk.GestureDrag ();
            Gtk.GestureZoom scale_gesture = new Gtk.GestureZoom ();

            move_gesture.drag_update.connect ((offset_x, offset_y) => {
                var result_x = this.center.x + ((offset_x - current_position.x > 0) ? 1 : -1) * (offset_x - current_position.x).abs ();
                var result_y = this.center.y + ((offset_y - current_position.y > 0) ? 1 : -1) * (offset_y - current_position.y).abs ();
                this.center = new Point (result_x, result_y);
                current_position = new Point (offset_x, offset_y);
                this.queue_draw ();
            });

            move_gesture.drag_end.connect (() => {
                current_position = new Point (0, 0);
            });

            scale_gesture.scale_changed.connect ((scale) => {
                var result = this.scale + ((float) current_scale - scale) * (this.scale.abs () * 2);
                if (result > 0) {
                    double widget_horizontal_center = this.get_content_width () / 2;
                    double widget_vertical_center = this.get_content_height () / 2;
                    double center_x = widget_horizontal_center - (widget_horizontal_center - this.center.x) * (this.scale / result);
                    double center_y = widget_vertical_center - (widget_vertical_center - this.center.y) * (this.scale / result);
                    this.center = new Point (center_x, center_y);
                    this.scale = result;
                    current_scale = scale;
                    this.queue_draw ();
                }
            });

            scale_gesture.end.connect (() => {
                current_scale = 1.0;
            });

            this.add_controller (move_gesture);
            this.add_controller (scale_gesture);
        }

        protected void draw (Gtk.DrawingArea drawing_area, Cairo.Context cairo, int width, int height) {
            this.draw_grid (drawing_area, cairo, width, height);
        }

        private void draw_grid (Gtk.DrawingArea drawing_area, Cairo.Context cairo, int width, int height) {
            cairo.set_source_rgb (0.5, 0.5, 0.5);

            cairo.set_line_width (0.5);

            this.draw_line (cairo, center.x, 0, center.x, height);
            this.draw_line (cairo, 0, center.y, width, center.y);

            cairo.set_line_width (0.1);

            double step = this.calculate_grid_step (scale);
            if (center.x < width) {
                for (double i = center.x + step; i < width; i += step) {
                    if (i < 0)continue;
                    this.draw_line (cairo, i, 0, i, height);
                }
            }
            if (center.x > 0) {
                for (double i = center.x - step; i > 0; i -= step) {
                    if (i > width)continue;
                    this.draw_line (cairo, i, 0, i, height);
                }
            }

            if (center.y < height) {
                for (double i = center.y + step; i < height; i += step) {
                    if (i < 0)continue;
                    this.draw_line (cairo, 0, i, width, i);
                }
            }
            if ((center.y > 0)) {
                for (double i = center.y - step; i > 0; i -= step) {
                    if (i > height)continue;
                    this.draw_line (cairo, 0, i, width, i);
                }
            }
        }

        private void draw_line (Cairo.Context cairo, double x1, double y1, double x2, double y2) {
            cairo.move_to (x1, y1);
            cairo.line_to (x2, y2);
            cairo.stroke ();
        }

        private double calculate_grid_step (double scale) {
            double result = 100 / scale;

            while (true) {
                if (result < 100)
                    result *= 2;
                else if (result > 240)
                    result /= 2;
                else break;
            }

            return result;
        }
    }
}