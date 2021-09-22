package models

type EmployeeReq struct {
	Company string `json:"company,omitempty"`
	Shop    string `json:"shop,omitempty"`
	Page    int    `json:"page"`
	PerPage int    `json:"per_page"`
}

type Employee struct {
	Company   string `db:"company" select:"company" json:"company"`
	Job       string `db:"job" json:"job"`
	Rating    string `db:"rating"  json:"rating"`
	FirstName string `db:"first_name" json:"first_name"`
	LastName  string `db:"last_name" json:"last_name"`
}
