package models

type PgDatabase struct {
	Name          string `db:"datname" json:"name"`
	DatCollate    string `db:"datcollate" json:"datcollate"`
	DatCtype      string `db:"datctype" json:"datctype"`
	DatIsTemplate string `db:"datistemplate" json:"datistemplate"`
	DatAllowConn  string `db:"datallowconn" json:"datallowconn"`
	DatConnLimit  string `db:"datconnlimit" json:"datconnlimit"`
}

func (p PgDatabase) TableName() string {
	return "pg_database"
}

type PgDatabaseVersion struct {
	Version  string `db:"version" select:"version" json:"version"`
}

func (p PgDatabaseVersion) TableName() string {
	return "pg_database"
}
