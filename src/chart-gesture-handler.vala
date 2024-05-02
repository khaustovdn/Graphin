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
        private Point default_center { get; set; default = new Point (0, 0); }
        private double default_zoom { get; set; default = 1.0; }

        public ChartGestureHandler (ChartParameters parameters) {
            Object (parameters: parameters);
        }

        public void center_reset () {
            this.default_center = new Point (0, 0);
        }

        public void zoom_reset () {
            this.default_zoom = 1.0;
        }

        public void handle_drag (double offset_x, double offset_y) {
            double dx = offset_x - this.default_center.x;
            double dy = offset_y - this.default_center.y;
            this.parameters.center = new Point (this.parameters.center.x + (dx > 0 ? 1 : -1) * dx.abs (),
                                                this.parameters.center.y + (dy > 0 ? 1 : -1) * dy.abs ());
            this.default_center = new Point (offset_x, offset_y);
        }

        public void handle_zoom (Gtk.GestureZoom controller, double scale) {
            double delta = (float) this.default_zoom - scale;
            this.default_zoom = scale;
            scale = this.parameters.zoom + delta * this.parameters.zoom.abs () * 2;
            this.update_zoom (controller.widget.get_width (), controller.widget.get_height (), scale);
        }

        public bool handle_scroll (Gtk.EventControllerScroll controller, double dx, double dy) {
            double scale = this.parameters.zoom + dy * this.parameters.zoom * 0.1;
            this.update_zoom (controller.widget.get_width (), controller.widget.get_height (), scale);
            return true;
        }

        private void update_zoom (double width, double height, double scale) {
            if (scale > 0 && scale < double.MAX) {
                bool center_in_range = this.parameters.center.x.abs () < int.MAX && this.parameters.center.y.abs () < int.MAX;
                if (center_in_range || !center_in_range && this.parameters.zoom / scale < 1) {
                    double widget_horizontal_center = width / 2, widget_vertical_center = height / 2;
                    double center_x = widget_horizontal_center - (widget_horizontal_center - this.parameters.center.x) * (this.parameters.zoom / scale);
                    double center_y = widget_vertical_center - (widget_vertical_center - this.parameters.center.y) * (this.parameters.zoom / scale);

                    this.parameters.center = new Point (center_x, center_y);
                    this.parameters.zoom = scale;
                }
            }
        }
    }
}