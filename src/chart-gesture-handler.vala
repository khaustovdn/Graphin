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
        public ChartParameters parameters { get; set; }
        private Point current_center { get; set; default = new Point (0, 0); }
        private double current_scale { get; set; default = 1.0; }

        public ChartGestureHandler (ChartParameters parameters) {
            Object (parameters: parameters);
        }

        public void current_center_reset () {
            this.current_center = new Point (0, 0);
        }

        public void current_scale_reset () {
            this.current_scale = 1.0;
        }

        public void handle_drag (double offset_x, double offset_y) {
            var dx = offset_x - this.current_center.x;
            var dy = offset_y - this.current_center.y;
            this.parameters.center = new Point (this.parameters.center.x + (dx > 0 ? 1 : -1) * dx.abs (),
                                                this.parameters.center.y + (dy > 0 ? 1 : -1) * dy.abs ());
            this.current_center = new Point (offset_x, offset_y);
        }

        public void handle_zoom (Gtk.GestureZoom controller, double scale) {
            var delta = (float) this.current_scale - scale;
            var result = this.parameters.zoom + delta * this.parameters.zoom.abs () * 2;

            if (result > 0 && result < double.MAX) {
                double widget_horizontal_center = 0.0, widget_vertical_center = 0.0;
                controller.get_bounding_box_center (out widget_horizontal_center, out widget_vertical_center);
                double center_x = widget_horizontal_center - (widget_horizontal_center - this.parameters.center.x) * (this.parameters.zoom / result);
                double center_y = widget_vertical_center - (widget_vertical_center - this.parameters.center.y) * (this.parameters.zoom / result);

                this.parameters.center = new Point (center_x, center_y);
                this.parameters.zoom = result;
                this.current_scale = scale;
            }
        }

        public bool handle_scroll (Gtk.EventControllerScroll controller, double dx, double dy) {
            double result = this.parameters.zoom + dy * this.parameters.zoom * 0.1;

            if (result > 0 && result < double.MAX) {
                this.parameters.zoom = result;
            }

            return true;
        }
    }
}