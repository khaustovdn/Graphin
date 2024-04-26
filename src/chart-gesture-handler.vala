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
        private Point current_center { get; set; default = new Point (0, 0); }
        private double current_scale { get; set; default = 1.0; }

        public ChartGestureHandler () {
            Object ();
        }

        public void current_center_reset () {
            this.current_center = new Point (0, 0);
        }

        public void current_scale_reset () {
            this.current_scale = 1.0;
        }

        public void handle_move (Point offset_position, ref Point main_center) {
            var dx = offset_position.x - this.current_center.x;
            var dy = offset_position.y - this.current_center.y;
            main_center = new Point (main_center.x + (dx > 0 ? 1 : -1) * dx.abs (),
                                     main_center.y + (dy > 0 ? 1 : -1) * dy.abs ());
            this.current_center = new Point (offset_position.x, offset_position.y);
        }

        public void handle_scale (double width, double height, double scale, ref Point center, ref double main_scale) {
            var delta = (float) this.current_scale - scale;
            var result = main_scale + delta * main_scale.abs () * 2;

            if (result > 0) {
                double widget_horizontal_center = width / 2;
                double widget_vertical_center = height / 2;
                double center_x = widget_horizontal_center - (widget_horizontal_center - center.x) * (main_scale / result);
                double center_y = widget_vertical_center - (widget_vertical_center - center.y) * (main_scale / result);

                center = new Point (center_x, center_y);
                main_scale = result;
                this.current_scale = scale;
            }
        }
    }
}