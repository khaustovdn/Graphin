/* window.vala
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
    [GtkTemplate (ui = "/io/github/Graphin/ui/window.ui")]
    public class Window : Adw.ApplicationWindow {
        [GtkChild]
        public unowned Adw.Bin chart_bin;

        private Chart chart { get; set; }

        public Window (Gtk.Application app) {
            Object (application: app);
        }

        construct {
            Gee.ArrayList<Point> points = new Gee.ArrayList<Point>.wrap ({
                new Point (10.0, 100),
                new Point (20.0, 130),
                new Point (30.0, 30),
                new Point (40.0, 80),
                new Point (50.0, 60),
                new Point (60.0, 90),
                new Point (70.0, 100),
                new Point (80.0, 110),
                new Point (90.0, 90),
                new Point (100.0, 0),
                new Point (110.0, 50),
                new Point (120.0, 10),
            });

            this.chart = new Chart ();
            ChartLineSerie serie = new ChartLineSerie ();
            serie.points.add_all (points);
            this.chart.series.add (serie);
            this.chart_bin.set_child (this.chart);
        }
    }
}