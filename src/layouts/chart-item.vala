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
        public ChartItem () {
            Object ();
        }

        construct {
            this.set_draw_func (draw);
        }

        private void draw (Gtk.DrawingArea drawing_area, Cairo.Context cairo, int width, int height) {
            cairo.set_source_rgb (0.2, 0.8, 0.2);
            cairo.set_line_width (100.0);
            cairo.move_to (0, 0);
            cairo.line_to (width, height);
            cairo.stroke ();
        }
    }
}