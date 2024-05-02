/* chart-extremes.vala
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

 //need to edit

namespace Graphin {
    public class ChartExtremes : Object {
        public Gee.ArrayList<Point> max_points { get; set; }
        public Gee.ArrayList<Point> min_points { get; set; }
        public Point max_point { get; set; }
        public Point min_point { get; set; }

        public ChartExtremes() {
            Object();
        }

        public void calculate_max_point(Gee.ArrayList<Point> points) {
            this.max_point = points.first();

            for (int i = 0; i < points.size; i++) {
                if (this.max_point.y < points[i].y) {
                    this.max_point = points[i];
                }
            }
        }

        public void calculate_min_point(Gee.ArrayList<Point> points) {
            this.min_point = points.first();

            for (int i = 0; i < points.size; i++) {
                if (this.min_point.y > points[i].y) {
                    this.min_point = points[i];
                }
            }
        }

        public void calculate_max_points(Gee.ArrayList<Point> points) {
            this.max_points = new Gee.ArrayList<Point> ();

            for (int i = 0; i < points.size; i++) {
                if (points.size >= 3 && i > 0 && i < points.size - 1 && points[i].y > points[i - 1].y && points[i].y > points[i + 1].y) {
                    this.max_points.add(points[i]);
                } else if (points.size >= 2 && i == 0 && points[i].y > points[i + 1].y) {
                    this.max_points.add(points[i]);
                } else if (points.size >= 2 && i == points.size - 1 && points[i - 1].y < points[i].y) {
                    this.max_points.add(points[i]);
                }
            }
        }

        public void calculate_min_points(Gee.ArrayList<Point> points) {
            this.min_points = new Gee.ArrayList<Point> ();

            for (int i = 0; i < points.size; i++) {
                if (points.size >= 3 && i > 0 && i < points.size - 1 && points[i].y < points[i - 1].y && points[i].y < points[i + 1].y) {
                    this.min_points.add(points[i]);
                } else if (points.size >= 2 && i == 0 && points[i].y < points[i + 1].y) {
                    this.min_points.add(points[i]);
                } else if (points.size >= 2 && i == points.size - 1 && points[i - 1].y > points[i].y) {
                    this.min_points.add(points[i]);
                }
            }
        }
    }
}