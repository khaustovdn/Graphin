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
        public ChartLineSerie(ChartParameters parameters) {
            Object(parameters: parameters);
        }

        protected override bool should_skip_point(int index, ChartExtremes extremes, double width, double height) {
            return (is_point_outside_left_boundary(this.points.last()) ||
                    is_point_outside_right_boundary(this.points.first(), width) ||
                    is_point_outside_top_boundary(extremes.min_point) ||
                    is_point_outside_bottom_boundary(extremes.max_point, height)) ||
                   (index > 0 && index < this.points.size - 1 &&
                    is_point_outside_top_boundary(this.points[index - 1]) &&
                    is_point_outside_top_boundary(this.points[index]) &&
                    is_point_outside_top_boundary(this.points[index + 1])) ||
                   (index > 0 && index < this.points.size - 1 &&
                    is_point_outside_bottom_boundary(this.points[index - 1], height) &&
                    is_point_outside_bottom_boundary(this.points[index], height) &&
                    is_point_outside_bottom_boundary(this.points[index + 1], height)) ||
                   (index < this.points.size - 1 &&
                    is_point_outside_left_boundary(this.points[index + 1]) &&
                    is_point_outside_left_boundary(this.points[index])) ||
                   (index > 0 &&
                    is_point_outside_right_boundary(this.points[index - 1], width) &&
                    is_point_outside_right_boundary(this.points[index], height));
        }

        protected override void move_to_initial_point(Cairo.Context cairo, int index, double width, double height) {
            if (index > 0 && is_point_outside_top_boundary(this.points[index - 1]) && !is_point_outside_top_boundary(this.points[index])) {
                cairo.move_to(parameters.center.x + calculate_vertical_end_point(index, 0), 0);
            } else if (index > 0 && is_point_outside_bottom_boundary(this.points[index - 1], height) && !is_point_outside_bottom_boundary(this.points[index], height)) {
                cairo.move_to(parameters.center.x + calculate_vertical_end_point(index, height), height);
            } else if (index < this.points.size - 1 && is_point_outside_left_boundary(this.points[index + 1])) {
                cairo.move_to(0, parameters.center.y - calculate_horizontal_end_point(index + 1, width));
            } else if (index == 0) {
                cairo.move_to(parameters.center.x + this.points[index].x / parameters.zoom, parameters.center.y - this.points[index].y / parameters.zoom);
            }
        }

        protected override void draw_line_to_point(Cairo.Context cairo, int index, double width, double height) {
            if (index > 0 && !is_point_outside_top_boundary(this.points[index - 1]) && is_point_outside_top_boundary(this.points[index])) {
                cairo.line_to(parameters.center.x + calculate_vertical_end_point(index, 0), 0);
            } else if (index > 0 && !is_point_outside_bottom_boundary(this.points[index - 1], height) && is_point_outside_bottom_boundary(this.points[index], height)) {
                cairo.line_to(parameters.center.x + calculate_vertical_end_point(index, height), height);
            } else if (index > 0 && is_point_outside_right_boundary(this.points[index], width)) {
                cairo.line_to(width, parameters.center.y - calculate_horizontal_end_point(index, width));
            } else {
                cairo.line_to(parameters.center.x + this.points[index].x / parameters.zoom, parameters.center.y - points[index].y / parameters.zoom);
            }
        }

        private double calculate_horizontal_end_point(int index, double width) {
            double x_difference = calculate_difference(this.points[index].x / parameters.zoom, this.points[index - 1].x / parameters.zoom);
            double y_difference = calculate_difference(this.points[index].y / parameters.zoom, this.points[index - 1].y / parameters.zoom);
            return (y_difference * calculate_difference(width - parameters.center.x, this.points[index - 1].x / parameters.zoom) / x_difference) + (this.points[index - 1].y / parameters.zoom);
        }

        private double calculate_vertical_end_point(int index, double height) {
            double x_difference = calculate_difference(this.points[index].x / parameters.zoom, this.points[index - 1].x / parameters.zoom);
            double y_difference = calculate_difference(this.points[index].y / parameters.zoom, this.points[index - 1].y / parameters.zoom);
            return (x_difference * calculate_difference(parameters.center.y - height, this.points[index - 1].y / parameters.zoom) / y_difference) + (this.points[index - 1].x / parameters.zoom);
        }

        private double calculate_difference(double x, double y) {
            return x - y;
        }
    }
}