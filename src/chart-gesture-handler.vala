/* chart-gesture-handler.vala
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
    public class ChartGestureHandler : Object {
        public Chart chart { private get; construct; }
        private Gtk.GestureDrag move_gesture { get; set; default = new Gtk.GestureDrag (); }
        private Gtk.GestureZoom scale_gesture { get; set; default = new Gtk.GestureZoom (); }
        private Point current_center { get; set; default = new Point (0, 0); }
        private double current_scale { get; set; default = 1.0; }

        public ChartGestureHandler (Chart chart) {
            Object (chart: chart);
        }

        construct {
            move_gesture.drag_update.connect ((offset_x, offset_y) => {
                handle_move (new Point (offset_x, offset_y));
                chart.queue_draw ();
            });
            move_gesture.drag_end.connect (() => {
                current_center_reset ();
            });

            scale_gesture.scale_changed.connect ((scale) => {
                handle_scale (chart.content_width, chart.content_height, scale);
                chart.queue_draw ();
            });
            scale_gesture.end.connect (() => {
                current_scale_reset ();
            });

            chart.add_controller (move_gesture);
            chart.add_controller (scale_gesture);
        }

        public void current_center_reset () {
            this.current_center = new Point (0, 0);
        }

        public void current_scale_reset () {
            this.current_scale = 1.0;
        }

        public void handle_move (Point offset_position) {
            var dx = offset_position.x - this.current_center.x;
            var dy = offset_position.y - this.current_center.y;
            chart.center = new Point (chart.center.x + (dx > 0 ? 1 : -1) * dx.abs (),
                                      chart.center.y + (dy > 0 ? 1 : -1) * dy.abs ());
            this.current_center = new Point (offset_position.x, offset_position.y);
        }

        public void handle_scale (double width, double height, double scale) {
            var delta = (float) this.current_scale - scale;
            var result = chart.scale + delta * chart.scale.abs () * 2;

            if (result > 0) {
                double widget_horizontal_center = width / 2;
                double widget_vertical_center = height / 2;
                double center_x = widget_horizontal_center - (widget_horizontal_center - chart.center.x) * (chart.scale / result);
                double center_y = widget_vertical_center - (widget_vertical_center - chart.center.y) * (chart.scale / result);

                chart.center = new Point (center_x, center_y);
                chart.scale = result;
                this.current_scale = scale;
            }
        }
    }
}