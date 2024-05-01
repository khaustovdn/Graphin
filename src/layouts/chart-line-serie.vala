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

        public override void draw(Gtk.DrawingArea drawing_area, Cairo.Context cairo, int width, int height) {
            cairo.set_line_width(1.0);

            ChartExtremes extremes = new ChartExtremes(this.points);
            Point max_point = extremes.calculate_max_point(), min_point = extremes.calculate_min_point();

            for (int i = 0; i < this.points.size; i++) {
                if (should_skip_point(i, max_point, min_point, width, height)) {
                    cairo.stroke();
                    continue;
                }
                move_to_initial_point(cairo, i, width, height);
                draw_line_to_point(cairo, i, width, height);
            }

            cairo.stroke();
        }

        private bool should_skip_point(int index, Point max_point, Point min_point, double width, double height) {
            return (is_point_outside_left_boundary(this.points.last()) || is_point_outside_right_boundary(this.points.first(), width)) ||
                   (is_point_outside_top_boundary(min_point) || is_point_outside_bottom_boundary(max_point, height)) ||
                   (index > 0 && index < this.points.size - 1 && is_point_outside_top_boundary(this.points[index - 1]) && is_point_outside_top_boundary(this.points[index]) && is_point_outside_top_boundary(this.points[index + 1])) ||
                   (index > 0 && index < this.points.size - 1 && is_point_outside_bottom_boundary(this.points[index - 1], height) && is_point_outside_bottom_boundary(this.points[index], height) && is_point_outside_bottom_boundary(this.points[index + 1], height)) ||
                   (index < this.points.size - 1 && is_point_outside_left_boundary(this.points[index + 1]) && is_point_outside_left_boundary(this.points[index])) ||
                   (index > 0 && is_point_outside_right_boundary(this.points[index], height) && is_point_outside_right_boundary(this.points[index - 1], width));
        }

        private bool is_point_outside_left_boundary(Point point) {
            return parameters.center.x + point.x / parameters.zoom < 0;
        }

        private bool is_point_outside_right_boundary(Point point, double width) {
            return parameters.center.x + point.x / parameters.zoom > width;
        }

        private bool is_point_outside_top_boundary(Point point) {
            return parameters.center.y - point.y / parameters.zoom < 0;
        }

        private bool is_point_outside_bottom_boundary(Point point, double height) {
            return parameters.center.y - point.y / parameters.zoom > height;
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

        private void move_to_initial_point(Cairo.Context cairo, int index, double width, double height) {
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

        private void draw_line_to_point(Cairo.Context cairo, int index, double width, double height) {
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

        private double calculate_difference(double x, double y) {
            return x - y;
        }
    }
}