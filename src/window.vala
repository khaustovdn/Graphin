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
            Gee.ArrayList<Point> points = new Gee.ArrayList<Point> ();
            Gee.ArrayList<Point> points_bar = new Gee.ArrayList<Point> ();
            for (double i = -10; i <= 10; i += 0.01) {
                points.add (new Point (i, Math.cos (i) * i));
            }
            for (double i = -10; i <= 10; i += 1) {
                points_bar.add (new Point (i, Math.cos (i) * i));
            }

            this.chart = new Chart (new Point (20.0, 20.0), 1.0, ChartAxisStatus.ENABLE, ChartGridStatus.ENABLE);
            ChartLineSerie serie = new ChartLineSerie (chart.parameters);
            ChartBarSerie serie_bar = new ChartBarSerie (chart.parameters);
            serie.points.add_all (points);
            serie_bar.points.add_all (points_bar);
            //this.chart.series.add (serie);
            this.chart.series.add (serie_bar);
            this.chart_bin.set_child (this.chart);
        }
    }
}