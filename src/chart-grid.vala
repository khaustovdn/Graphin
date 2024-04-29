/* chart-grid.vala
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
    public enum ChartGridStatus {
        ENABLE,
        DISABLE
    }

    public class ChartGrid : Gtk.DrawingArea, IChartDrawable {
        public ChartParameters parameters { get; construct; }

        public ChartGrid (ChartParameters parameters) {
            Object (parameters: parameters);
        }

        public void draw (Gtk.DrawingArea drawing_area, Cairo.Context cairo, int width, int height) {
            cairo.set_source_rgb (0.5, 0.5, 0.5);
            cairo.set_line_width (0.1);

            double step = this.calculate_grid_step (parameters.zoom);

            for (double i = parameters.center.x + step, j = parameters.center.x - step; i < width || j > 0; i += step, j -= step) {
                if (i >= 0 && i <= width) {
                    cairo.move_to (i, 0.0);
                    cairo.line_to (i, height);
                }
                if (j >= 0 && j <= width) {
                    cairo.move_to (j, 0.0);
                    cairo.line_to (j, height);
                }
            }

            for (double i = parameters.center.y + step, j = parameters.center.y - step; i < height || j > 0; i += step, j -= step) {
                if (i >= 0 && i <= height) {
                    cairo.move_to (0.0, i);
                    cairo.line_to (width, i);
                }
                if (j >= 0 && j <= height) {
                    cairo.move_to (0.0, j);
                    cairo.line_to (width, j);
                }
            }

            cairo.stroke ();
        }

        private double calculate_grid_step (double scale) {
            double result = 100 / scale;

            while (result < 100 || result > 240) {
                result = (result < 100) ? result * 2 : result / 2;
            }

            return result;
        }
    }
}