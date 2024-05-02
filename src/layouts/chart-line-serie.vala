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
            base.draw(drawing_area, cairo, width, height);
            for (int i = 0; i < this.points.size; i++) {
                if (this.should_skip_point(i, width, height)) {
                    cairo.stroke();
                    continue;
                }

                this.move_to_initial_point(cairo, i, width, height);
                this.draw_line_to_point(cairo, i, width, height);
            }
            cairo.stroke();
        }

        protected override void move_to_initial_point(Cairo.Context cairo, int index, double width, double height) {
            if (index > 0 && this.is_point_outside_top_boundary(this.points[index - 1]) && !this.is_point_outside_top_boundary(this.points[index])) {
                cairo.move_to(this.parameters.center.x + this.calculate_vertical_end_point(index, 0), 0);
            } else if (index > 0 && this.is_point_outside_bottom_boundary(this.points[index - 1], height) && !this.is_point_outside_bottom_boundary(this.points[index], height)) {
                cairo.move_to(this.parameters.center.x + this.calculate_vertical_end_point(index, height), height);
            } else if (index < this.points.size - 1 && this.is_point_outside_left_boundary(this.points[index + 1])) {
                cairo.move_to(0, this.parameters.center.y - this.calculate_horizontal_end_point(index + 1, width));
            } else if (index == 0) {
                cairo.move_to(this.parameters.center.x + this.points[index].x / this.parameters.zoom, this.parameters.center.y - this.points[index].y / this.parameters.zoom);
            }
        }

        protected override void draw_line_to_point(Cairo.Context cairo, int index, double width, double height) {
            if (index > 0 && !this.is_point_outside_top_boundary(this.points[index - 1]) && this.is_point_outside_top_boundary(this.points[index])) {
                cairo.line_to(this.parameters.center.x + this.calculate_vertical_end_point(index, 0), 0);
            } else if (index > 0 && !this.is_point_outside_bottom_boundary(this.points[index - 1], height) && this.is_point_outside_bottom_boundary(this.points[index], height)) {
                cairo.line_to(this.parameters.center.x + this.calculate_vertical_end_point(index, height), height);
            } else if (index > 0 && this.is_point_outside_right_boundary(this.points[index], width)) {
                cairo.line_to(width, this.parameters.center.y - this.calculate_horizontal_end_point(index, width));
            } else {
                cairo.line_to(this.parameters.center.x + this.points[index].x / this.parameters.zoom, this.parameters.center.y - this.points[index].y / this.parameters.zoom);
            }
        }

        protected override bool should_skip_point(int index, double width, double height) {
            return (this.is_point_outside_left_boundary(this.points.last()) ||
                    this.is_point_outside_right_boundary(this.points.first(), width) ||
                    this.is_point_outside_top_boundary(this.extremes.min_point) ||
                    this.is_point_outside_bottom_boundary(this.extremes.max_point, height)) ||
                   (index > 0 && index < this.points.size - 1 &&
                    this.is_point_outside_top_boundary(this.points[index - 1]) &&
                    this.is_point_outside_top_boundary(this.points[index]) &&
                    this.is_point_outside_top_boundary(this.points[index + 1])) ||
                   (index > 0 && index < this.points.size - 1 &&
                    this.is_point_outside_bottom_boundary(this.points[index - 1], height) &&
                    this.is_point_outside_bottom_boundary(this.points[index], height) &&
                    this.is_point_outside_bottom_boundary(this.points[index + 1], height)) ||
                   (index < this.points.size - 1 &&
                    this.is_point_outside_left_boundary(this.points[index + 1]) &&
                    this.is_point_outside_left_boundary(this.points[index])) ||
                   (index > 0 &&
                    this.is_point_outside_right_boundary(this.points[index - 1], width) &&
                    this.is_point_outside_right_boundary(this.points[index], height));
        }

        private double calculate_horizontal_end_point(int index, double width) {
            double x_difference = this.calculate_difference(this.points[index].x / this.parameters.zoom, this.points[index - 1].x / this.parameters.zoom);
            double y_difference = this.calculate_difference(this.points[index].y / this.parameters.zoom, this.points[index - 1].y / this.parameters.zoom);
            return (y_difference * this.calculate_difference(width - this.parameters.center.x, this.points[index - 1].x / this.parameters.zoom) / x_difference) + (this.points[index - 1].y / this.parameters.zoom);
        }

        private double calculate_vertical_end_point(int index, double height) {
            double x_difference = this.calculate_difference(this.points[index].x / this.parameters.zoom, this.points[index - 1].x / this.parameters.zoom);
            double y_difference = this.calculate_difference(this.points[index].y / this.parameters.zoom, this.points[index - 1].y / this.parameters.zoom);
            return (x_difference * this.calculate_difference(this.parameters.center.y - height, this.points[index - 1].y / this.parameters.zoom) / y_difference) + (this.points[index - 1].x / this.parameters.zoom);
        }

        private double calculate_difference(double x, double y) {
            return x - y;
        }
    }
}