Description
===========

Generic cookbook for installing or removing software.

Attributes
==========

* `node["add_remove_software"]['packages']['to_install']` - A list of individual packages to be installed
* `node["add_remove_software"]['packages']['to_remove']` - A list of individual packages to be removed
* `node["add_remove_software"]['groups']['to_install']` - A group of packages to be installed
* `node["add_remove_software"]['groups']['to_remove']` - A group of packages to be removed

You can define your own groups of packages like this:

```
default[:add_remove_software][:groups][:basic] = []
default[:add_remove_software][:groups][:office] = [
                                                   'libreoffice-writer',
                                                   'libreoffice-calc',
                                                   'libreoffice-impress'
                                                  ]
default[:add_remove_software][:groups][:internet] = [
                                                     'firefox',
                                                     'firefox-firma'
                                                    ]
```



License and Author
==================

Author::

* Juanje Ojeda (<jojeda@emergya.com>)

Copyright 2011 Junta de Andalucía

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

