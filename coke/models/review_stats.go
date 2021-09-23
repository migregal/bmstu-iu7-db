package models

type ReviewStats struct {
	Date     string `db:"date" json:"date"`
	Average  string `db:"average" json:"average"`
	Negative string `db:"negative" json:"negative"`
	Neutral  string `db:"neutral" json:"neutral"`
	Positive string `db:"positive" json:"positive"`
	Total    string `db:"total" json:"total"`
}

func (p ReviewStats) TableName() string {
	return "review_stats"
}
