# Lib: Realm Info

## [13](https://github.com/phanx-wow/LibRealmInfo/tree/13) (2018-07-29)
[Full Changelog](https://github.com/phanx-wow/LibRealmInfo/compare/12...13)

- Bump minor version  
- Update TOC  
- Workaround for missing data for Chinese realms  
- Remove discontinued servers (fixes #13)  
- Include nameless "host" servers in connected realm list  
- Update readme  
- Remove unused code  
- Use helper function to generate API names  
- Convert snake case variable names to camel case  
- Remove realm entries for nameless realms  
    These are used to host connected realm groups. They are not included  
    in the realm info from the Battle.net API, but are included (as the  
    connected group ID) from the connected realm info API. To support  
    region detection, we now add these to the realm info table dynamically  
    when unpacking the connected realm info.  
- Return a copy of the connections list  
    Otherwise the client addon can modify the library's internal data,  
    since tables in Lua are passed by reference.  
- Update connected realm data from Battle.net API  
- Update realm data from Blizzard Developer API  
- Remove LOD flag  
