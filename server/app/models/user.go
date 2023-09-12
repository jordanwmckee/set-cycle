package models

import (
	"time"

	"github.com/jordanwmckee/sets-app/utils/db"
	"github.com/jordanwmckee/sets-app/utils/token"

	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type User struct {
	AppleUserID string `gorm:"primaryKey;not null;size:255" json:"apple_user_id"`
	CreatedAt   time.Time
	UpdatedAt   time.Time
	DeletedAt   gorm.DeletedAt `gorm:"index"`
}

// GetUserByID is a model function that returns a user by ID.
func GetUserByID(uid string) (User, error) {
	var u User

	DB := db.GetDB()
	if err := DB.Where("apple_user_id = ?", uid).First(&u).Error; err != nil {
		return User{}, err
	}

	return u, nil
}

// UserExists is a model function that checks if a user exists in the database.
func (u *User) Exists() bool {
	DB := db.GetDB()

	if err := DB.Where("apple_user_id = ?", u.AppleUserID).First(&u).Error; err != nil {
		return false
	}

	return true
}

// VerifyPassword is a model function that compares a password to a hashed password.
// It returns an error if the passwords do not match.
func VerifyPassword(password, hashedPassword string) error {
	return bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(password))
}

// LoginCheck is a model function that checks a username and password against the database.
// It returns a token response and an error.
func LoginCheck(uid string) (token.TokenResponse, error) {
	var err error

	u := User{}

	DB := db.GetDB()
	err = DB.Model(User{}).Where("apple_user_id = ?", uid).Take(&u).Error

	if err != nil {
		return token.TokenResponse{}, err
	}

	tokens, err := token.GenerateTokenPair(u.AppleUserID)

	if err != nil {
		return token.TokenResponse{}, err
	}

	return token.TokenResponse{
		AccessToken:  tokens.AccessToken,
		RefreshToken: tokens.RefreshToken,
	}, nil
}

// SaveUser is a model function that saves a user to the database.
func (u *User) SaveUser() (*User, error) {
	DB := db.GetDB()
	err := DB.Create(&u).Error

	if err != nil {
		return &User{}, err
	}

	return u, nil
}

// DeleteUser deletes a given user from the database by ID.
func DeleteUser(uid string) error {
	DB := db.GetDB()

	u, err := GetUserByID(uid)

	if err != nil {
		return err
	}

	// delete user from database
	err = DB.Delete(&u).Error

	if err != nil {
		return err
	}

	return nil
}
