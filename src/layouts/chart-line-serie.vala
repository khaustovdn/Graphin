/* chart-line-serie.vala
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
    public class ChartLineSerie : ChartSerie, IChartDrawable {
        public ChartLineSerie (ChartParameters parameters) {
            Object (parameters: parameters);
        }

        public override void draw (Gtk.DrawingArea drawing_area, Cairo.Context cairo, int width, int height) {
            cairo.set_line_width (1.0);
            cairo.move_to (parameters.center.x + this.points.first ().x / parameters.scale, parameters.center.y - this.points.first ().y / parameters.scale);
            foreach (var point in this.points) {
                cairo.line_to (parameters.center.x + point.x / parameters.scale, parameters.center.y - point.y / parameters.scale);
            }
            cairo.stroke ();
        }
    }
}