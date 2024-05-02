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
        public ChartBarSerie(ChartParameters parameters) {
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
                cairo.stroke();
            }
        }

        protected override void move_to_initial_point(Cairo.Context cairo, int index, double width, double height) {
            if (this.is_point_outside_top_boundary(new Point(this.points[index].x, 0)) && !this.is_point_outside_top_boundary(this.points[index])) {
                cairo.move_to(this.parameters.center.x + this.points[index].x / this.parameters.zoom, 0);
            } else if (this.is_point_outside_bottom_boundary(new Point(this.points[index].x, 0), height) && !this.is_point_outside_bottom_boundary(this.points[index], height)) {
                cairo.move_to(this.parameters.center.x + this.points[index].x / this.parameters.zoom, height);
            } else {
                cairo.move_to(this.parameters.center.x + this.points[index].x / this.parameters.zoom, this.parameters.center.y);
            }
        }

        protected override void draw_line_to_point(Cairo.Context cairo, int index, double width, double height) {
            if (this.is_point_outside_top_boundary(this.points[index])) {
                cairo.line_to(this.parameters.center.x + this.points[index].x / this.parameters.zoom, 0);
            } else if (this.is_point_outside_bottom_boundary(this.points[index], height)) {
                cairo.line_to(this.parameters.center.x + this.points[index].x / this.parameters.zoom, height);
            } else {
                cairo.line_to(this.parameters.center.x + this.points[index].x / this.parameters.zoom, this.parameters.center.y - this.points[index].y / this.parameters.zoom);
            }
        }

        protected override bool should_skip_point(int index, double width, double height) {
            return (this.is_point_outside_left_boundary(this.points[index]) ||
                    this.is_point_outside_right_boundary(this.points[index], width) ||
                    this.is_point_outside_top_boundary(this.extremes.min_point) ||
                    this.is_point_outside_bottom_boundary(this.extremes.max_point, height)) ||
                   (this.is_point_outside_top_boundary(new Point(this.points[index].x, 0)) &&
                    this.is_point_outside_top_boundary(this.points[index]) ||
                    this.is_point_outside_bottom_boundary(new Point(this.points[index].x, 0), height) &&
                    this.is_point_outside_bottom_boundary(this.points[index], height));
        }
    }
}