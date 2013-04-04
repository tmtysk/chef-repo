nginx-dev Cookbook
==================
Setup and start Nginx development version with pagespeed module.

Requirements
------------
For Debian/Ubuntu OS only.

Attributes
----------

#### nginx-dev::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['nginx']['version']</tt></td>
    <td>String</td>
    <td>version number</td>
    <td><tt>1.3.15</tt></td>
  </tr>
  <tr>
    <td><tt>['nginx']['with_pagespeed']</tt></td>
    <td>Boolean</td>
    <td>Pagespeed module will be installed if true</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### nginx-dev::default

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[nginx-dev]"
  ]
}
```

License and Authors
-------------------
created by tmtysk, distributed under the MIT License.
