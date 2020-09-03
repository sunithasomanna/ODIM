module github.com/ODIM-Project/ODIM/svc-aggregation

go 1.13

require (
	github.com/ODIM-Project/ODIM/lib-dmtf v0.0.0-20200727115727-33d557ff397c
	github.com/ODIM-Project/ODIM/lib-messagebus v0.0.0-20200727103018-252e26a63065
	github.com/ODIM-Project/ODIM/lib-utilities v0.0.0-20200903074706-88a337f66fb7
	github.com/ODIM-Project/ODIM/svc-plugin-rest-client v0.0.0-20200727110501-4599893e44fd
	github.com/satori/go.uuid v1.2.0
	github.com/stretchr/testify v1.5.1
)

replace github.com/ODIM-Project/ODIM/lib-utilities => /home/arjun/go/src/github.com/a-ajith/ODIM/lib-utilities
