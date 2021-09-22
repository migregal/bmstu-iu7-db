package models

type ShopReq struct {
	Company string `json:"company,omitempty"`
	Shop    string `json:"shop,omitempty"`
}

type Shop struct {
	ID      string `db:"id" json:"id"`
	Company string `db:"company" json:"company"`
	Name    string `db:"name" json:"name"`
}
