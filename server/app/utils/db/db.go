package db

import (
	"gorm.io/gorm"
)

var instance *gorm.DB

// Initialize initializes the database instance once
func Initialize(dbInstance *gorm.DB) {
	instance = dbInstance
}

// GetDB returns the singleton database instance
func GetDB() *gorm.DB {
	return instance
}
