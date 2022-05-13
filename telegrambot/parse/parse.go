package main

import (
	"fmt"

	g "github.com/serpapi/google-search-results-golang"
)

func main(){

parameter := map[string]string{
    "q":            "Кон-тики",
    "tbm": "isch",
}

api := "1657431406911dda8fa44bfee556b2e58c573cdd6eaa37dfb15478f7210937e9"
query := g.NewGoogleSearch(parameter, api)
// Many search engine available: bing, yahoo, baidu, googemaps, googleproduct, googlescholar, ebay, walmart, youtube..

rsp, err := query.GetJSON()
println(err)
results := rsp["images_results"].([]interface{})
first_result := results[0].(map[string]interface{})
// fmt.Println(first_result["title"].(string))
fmt.Printf("%v", first_result["original"])
}

