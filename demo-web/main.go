package main

import (
	"database/sql"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	"runtime/debug"

	"github.com/zenazn/goji/web"

	_ "github.com/go-sql-driver/mysql"
	"github.com/gorilla/sessions"
	"github.com/zenazn/goji"
)

var (
	templates  *template.Template
	store      = sessions.NewCookieStore([]byte("secret???"))
	dbUsername = os.Getenv("MYSQL_ROOT_USERNAME")
	dbPassword = os.Getenv("MYSQL_ROOT_PASSWORD")
	dbEndpoint = os.Getenv("DB_ENDPOINT")
)

func main() {
	defer func() {
		if r := recover(); r != nil {
			log.Println(fmt.Sprintf("recover : %v", r))
			log.Println(fmt.Sprintf("stack trace : %s", string(debug.Stack())))
			os.Exit(1)
		}

		os.Exit(0)
	}()

	if dbUsername == "" {
		dbUsername = "root"
	}

	if dbPassword == "" {
		dbPassword = "root"
	}

	if dbEndpoint == "" {
		dbEndpoint = "localhost:3306"
	}

	vaildRequire(initRoute())
	startServe()
}

func vaildRequire(err error) {
	if err != nil {
		log.Fatal(err.Error())
	}
}

func vaildOptional(err error) {
	if err != nil {
		log.Println(err.Error())
	}
}

func initRoute() error {
	// 페이지 요청
	goji.Get("/", mainPage)
	goji.Post("/api/login", login)
	templates = template.Must(template.ParseGlob("tmpl/*.html"))

	return nil
}

func startServe() {
	log.Println("Running Demo WEB ...")

	staticFs := http.FileServer(http.Dir("static"))
	http.Handle("/static/", http.StripPrefix("/static/", staticFs))

	goji.Serve()
}

func mainPage(c web.C, w http.ResponseWriter, r *http.Request) {
	bg := os.Getenv("DEMO_WEB_BACKGROUND_COLOR")
	if bg == "" {
		bg = "gray-bg"
	}

	hostname, err := os.Hostname()
	if err != nil {
		log.Println(err.Error())
	}

	err = templates.ExecuteTemplate(w, "main", map[string]interface{}{
		"bg": bg,
		"hostname": hostname,
	})
	if err != nil {
		log.Println(err.Error())
	}
}

func login(c web.C, w http.ResponseWriter, r *http.Request) {
	username := r.FormValue("username")
	password := r.FormValue("password")

	db, err := sql.Open("mysql", fmt.Sprintf("%s:%s@tcp(%s)/demo", dbUsername, dbPassword, dbEndpoint))
	if err != nil {
		fmt.Fprintf(w, "Login 실패!\n데이터베이스에 연결할 수 없습니다.")
		return
	}
	defer db.Close()

	err = db.Ping()
	if err != nil {
		fmt.Fprintf(w, "Login 실패!\n데이터베이스에 연결할 수 없습니다.")
		return
	}

	var result string
	err = db.QueryRow(fmt.Sprintf("SELECT username FROM User WHERE username='%s' and password='%s'", username, password)).Scan(&result)
	if err != nil {
		fmt.Fprintf(w, "Login 실패!\n사용자 정보가 일치하지 않습니다.")
		return
	}

	fmt.Fprintf(w, fmt.Sprintf("%s님 Login 성공!", result))
}
