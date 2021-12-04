package models

type ManufacturerReq struct {
	Manufacturer string `json:"manufacturer"`
}

type Manufacturer struct {
	Manufacturer string `db:"manufacturer" json:"manufacturer"`
}

func (mg Manufacturer) TableName() string {
	return "goods"
}

type ManufacturerInfo struct {
	Manufacturer string `db:"manufacturer" json:"manufacturer,omitempty"`
	GoodId       string `db:"good_id" json:"good_id,omitempty"`
	Name         string `db:"name" json:"name,omitempty"`
	Year         int    `db:"year" json:"year,omitempty"`
}
