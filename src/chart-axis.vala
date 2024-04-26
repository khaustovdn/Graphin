/* chart-axis.vala
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
    public class ChartAxis : Object {
        public ChartAxis () {
            Object ();
        }

        public void draw (Gtk.DrawingArea drawing_area, Cairo.Context cairo, int width, int height, Point center) {
            cairo.set_source_rgb (0.5, 0.5, 0.5);
            cairo.set_line_width (0.5);

            cairo.move_to (center.x, 0.0);
            cairo.line_to (center.x, height);
            cairo.stroke ();

            cairo.line_to (0.0, center.y);
            cairo.line_to (width, center.y);
            cairo.stroke ();
        }
    }
}