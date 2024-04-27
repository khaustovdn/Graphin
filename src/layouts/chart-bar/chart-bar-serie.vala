/* chart-bar-serie.vala
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
    public class ChartBarSerie : ChartSerie {
        public ChartBarSerie () {
            Object ();
        }

        public override void draw (Gtk.DrawingArea drawing_area, Cairo.Context cairo, int width, int height) {
            cairo.set_line_width (4.0 / this.scale);
            foreach (var item in this.points) {
                cairo.move_to (this.center.x + item.x / this.scale, this.center.y);
                cairo.line_to (this.center.x + item.x / this.scale, this.center.y - item.y / this.scale);
                cairo.stroke ();
            }
        }
    }
}