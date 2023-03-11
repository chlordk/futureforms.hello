
TRUNCATE TABLE countries;

COPY public.countries (country_id, country_name) FROM stdin;
DK	Denmark
FI	Finland
SE	Sweden
CN	People's Republic of China
UK	United Kingdom
NO	Norway
BO	Bolivia
\.
