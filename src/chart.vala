/* chart.vala
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
    public class Chart : Gtk.DrawingArea {
        protected Point center { get; set; }
        protected double scale { get; set; }
        private ChartAxis axis { get; default = new ChartAxis (); }
        private ChartGrid grid { get; default = new ChartGrid (); }
        public Gee.ArrayList<Point> series { get; default = new Gee.ArrayList<Point> (); }

        construct {
            this.set_content_width (360);
            this.set_content_height (480);
            this.set_draw_func (draw);

            this.center = new Point (50.0, this.content_height - 50);
            this.scale = 1.0;

            this.setup_gestures ();
        }

        protected virtual void draw (Gtk.DrawingArea drawing_area, Cairo.Context cairo, int width, int height) {
            this.axis.draw (drawing_area, cairo, width, height, center);
            this.grid.draw (drawing_area, cairo, width, height, center, scale);
        }

        private void setup_gestures () {
            ChartGestureHandler gesture_handler = new ChartGestureHandler ();

            Gtk.GestureDrag move_gesture = new Gtk.GestureDrag ();
            Gtk.GestureZoom scale_gesture = new Gtk.GestureZoom ();

            move_gesture.drag_update.connect ((offset_x, offset_y) => {
                gesture_handler.handle_move (new Point (offset_x, offset_y), ref this._center);
                this.queue_draw ();
            });
            move_gesture.drag_end.connect (() => {
                gesture_handler.current_center_reset ();
            });

            scale_gesture.scale_changed.connect ((scale) => {
                gesture_handler.handle_scale (this.content_width, this.content_height, scale, ref this._center, ref this._scale);
                this.queue_draw ();
            });
            scale_gesture.end.connect (() => {
                gesture_handler.current_scale_reset ();
            });

            this.add_controller (move_gesture);
            this.add_controller (scale_gesture);
        }
    }
}