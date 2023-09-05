package models

import (
	"errors"
	"html"
	"strings"

	"github.com/jordanwmckee/sets-app/utils/token"

	"github.com/jinzhu/gorm"
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	gorm.Model
	Username string `gorm:"size:255;not null;unique" json:"username"`
	Password string `gorm:"size:255;not null;" json:"password"`
}

// GetUserByID is a model function that returns a user by ID.
func GetUserByID(uid uint) (User, error) {
	var u User

	if err := DB.First(&u, uid).Error; err != nil {
		return u, errors.New("user not found")
	}

	u.PrepareGive()

	return u, nil
}

// PrepareGive removes the password from a user object.
func (u *User) PrepareGive() {
	u.Password = ""
}

// VerifyPassword is a model function that compares a password to a hashed password.
// It returns an error if the passwords do not match.
func VerifyPassword(password, hashedPassword string) error {
	return bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(password))
}

// LoginCheck is a model function that checks a username and password against the database.
// It returns a token response and an error.
func LoginCheck(username string, password string) (token.TokenResponse, error) {
	var err error

	u := User{}

	err = DB.Model(User{}).Where("username = ?", username).Take(&u).Error

	if err != nil {
		return token.TokenResponse{}, err
	}

	err = VerifyPassword(password, u.Password)

	if err != nil && err == bcrypt.ErrMismatchedHashAndPassword {
		return token.TokenResponse{}, err
	}

	tokens, err := token.GenerateTokenPair(u.ID)

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
	err := DB.Create(&u).Error

	if err != nil {
		return &User{}, err
	}

	return u, nil
}

// BeforeSave encrypts a user's password before saving it to the database.
func (u *User) BeforeSave() error {
	// hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(u.Password), bcrypt.DefaultCost)

	if err != nil {
		return err
	}

	u.Password = string(hashedPassword)

	// remove spaces in username
	u.Username = html.EscapeString(strings.TrimSpace(u.Username))

	return nil
}

func DeleteUser(user_id uint) error {
	u, err := GetUserByID(user_id)

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
