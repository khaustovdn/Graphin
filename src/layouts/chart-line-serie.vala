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
            for (int i = 0; i < points.size; i++) {
                if (i < points.size - 1 && this.parameters.center.x + points[i].x / this.parameters.zoom < 0 && this.parameters.center.x + points[i + 1].x / this.parameters.zoom < 0)continue;
                else if (i < points.size - 1 && this.parameters.center.x + points[i + 1].x / this.parameters.zoom < 0) {
                    double x_difference = calculate_difference (points[i + 1].x / this.parameters.zoom, points[i].x / this.parameters.zoom);
                    double y_difference = calculate_difference (points[i + 1].y / this.parameters.zoom, points[i].y / this.parameters.zoom);
                    double calculated_y = (y_difference * calculate_difference (width - this.parameters.center.x, points[i].x / this.parameters.zoom) / x_difference) + (points[i].y / this.parameters.zoom);
                    cairo.move_to (0, calculated_y);
                } else if (i == 0) {
                    cairo.move_to (this.parameters.center.x + points[i].x / this.parameters.zoom, this.parameters.center.y - points[i].y / this.parameters.zoom);
                }

                if (i > 0 && this.parameters.center.x + points[i - 1].x / this.parameters.zoom > width && this.parameters.center.x + points[i].x / this.parameters.zoom > width)continue;
                else if (i > 0 && this.parameters.center.x + points[i].x / this.parameters.zoom > width) {
                    double x_difference = calculate_difference (points[i].x / this.parameters.zoom, points[i - 1].x / this.parameters.zoom);
                    double y_difference = calculate_difference (points[i].y / this.parameters.zoom, points[i - 1].y / this.parameters.zoom);
                    double calculated_y = (y_difference * calculate_difference (width - this.parameters.center.x, points[i - 1].x / this.parameters.zoom) / x_difference) + (points[i - 1].y / this.parameters.zoom);
                    cairo.line_to (width, this.parameters.center.y - calculated_y);
                } else if (i > 0) {
                    cairo.line_to (this.parameters.center.x + points[i].x / this.parameters.zoom, this.parameters.center.y - points[i].y / this.parameters.zoom);
                }
            }
            cairo.stroke ();
        }

        private double calculate_difference (double x, double y) {
            return x - y;
        }
    }
}