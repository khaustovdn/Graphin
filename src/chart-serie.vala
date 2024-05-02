/* chart-serie.vala
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
    public abstract class ChartSerie : Object, IChartDrawable {
        public ChartParameters parameters { get; construct; }
        public ChartExtremes extremes { get; set; }
        public Gee.ArrayList<Point> points { get; default = new Gee.ArrayList<Point> (); }
        public void draw(Gtk.DrawingArea drawing_area, Cairo.Context cairo, int width, int height) {
            cairo.set_line_width(4.0);

            if (points.size > 0)extremes = new ChartExtremes(this.points);

            for (int i = 0; i < this.points.size; i++) {
                if (should_skip_point(i, extremes, width, height)) {
                    cairo.stroke();
                    continue;
                }

                move_to_initial_point(cairo, i, width, height);
                draw_line_to_point(cairo, i, width, height);
                cairo.stroke();
            }
        }

        protected virtual bool should_skip_point(int index, ChartExtremes extremes, double width, double height) {
            return extremes == null;
        }

        protected abstract void move_to_initial_point(Cairo.Context cairo, int index, double width, double height);
        protected abstract void draw_line_to_point(Cairo.Context cairo, int index, double width, double height);

        protected bool is_point_outside_left_boundary(Point point) {
            return parameters.center.x + point.x / parameters.zoom < 0;
        }

        protected bool is_point_outside_right_boundary(Point point, double width) {
            return parameters.center.x + point.x / parameters.zoom > width;
        }

        protected bool is_point_outside_top_boundary(Point point) {
            return parameters.center.y - point.y / parameters.zoom < 0;
        }

        protected bool is_point_outside_bottom_boundary(Point point, double height) {
            return parameters.center.y - point.y / parameters.zoom > height;
        }
    }
}