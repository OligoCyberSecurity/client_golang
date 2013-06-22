# Copyright 2013 Prometheus Team
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

MAKE_ARTIFACTS = search_index

all: test

build:
	$(MAKE) -C prometheus build
	$(MAKE) -C examples build

test: build
	$(MAKE) -C prometheus test
	$(MAKE) -C examples test

advice: test
	$(MAKE) -C prometheus advice
	$(MAKE) -C examples advice

format:
	find . -iname '*.go' -exec gofmt -w -s=true '{}' ';'

search_index:
	godoc -index -write_index -index_files='search_index'

documentation: search_index
	godoc -http=:6060 -index -index_files='search_index'

clean:
	$(MAKE) -C examples clean
	rm -f $(MAKE_ARTIFACTS)
	find . -iname '*~' -exec rm -f '{}' ';'
	find . -iname '*#' -exec rm -f '{}' ';'

.PHONY: advice build clean documentation format test