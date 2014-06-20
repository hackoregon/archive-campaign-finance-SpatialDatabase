\o /gisdata/bash/national.bash
\t
\a
SELECT loader_generate_nation_script('sh');
\o
\o /gisdata/bash/oregon.bash
SELECT loader_generate_script(ARRAY['OR'], 'sh');
\o
