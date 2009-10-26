# mongrel-cluster-refresh

Send graceful restart signal to most resource intensive processes in a mongrel cluster. cluster::refresh finds the cluster processes by inspecting the mongrel_cluster.yml then looking up the process' MEM and CPU usage and sorting them by MEM usage, CPU usage and process ID. Then the top N processes specified, or 1/3 of the cluster by default, are sent the USR2 signal which instructs the mongrel process to restart itself.

## Usage

* gem install mongrel-cluster-refresh -s http://gemcutter.org
* mongrel cluster::refresh -C /path/to/mongrel_cluster.yml

## Options

* -C, --config PATH - Path to cluster configuration file; defaults to config/mongrel_cluster.yml in the current working directory
* -R, --refresh NUM - Number of mongrels to refresh; defaults to 1/3 of the <tt>servers</tt> directive in your mongrel_cluster.yml
* --clean - Remove orphaned pid files

## License

Copyright (c) 2009 Ryan Carmelo Briones &lt;<ryan.briones@brionesandco.com>&gt;

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
