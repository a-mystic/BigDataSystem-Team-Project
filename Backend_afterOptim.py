import pymongo
from fastapi import FastAPI

# 서버실행코드 uvicorn Backend_afterOptim:app --reload

app = FastAPI()
client = pymongo.MongoClient('localhost', 27017)
originalCollection = client["Project"]["Movies"]

@app.get("/")
async def requestMovies(genres: str, recommendedMovieList: str):
    pipelineGenreKeywords = genres.split(',')
    if recommendedMovieList == '':
        recommendedMovieList = []
    else:
        recommendedMovieList = list(map(int, recommendedMovieList.split(',')))
    
# 사용예시
#     db.Movies.aggregate([
#         {"$project": {"_id": 0, "id": 1, "title": 1, "revenue": 1, "genres": 1, "poster_path": 1, "vote_average": 1}},
#         {$match: {$and: [{"genres": {$in: ["Music", "Fantasy", "Drama"]}}, {"id": {$nin: [1224207,361743,424694,150540,321612,209112,872585,278927,758891,674,353486,346698,168259,12445,49026,122917,557,49051,671,597,672,301528,121,330457,779029,1189582,122,285,297762,1270893,109445,50620,1286020,810,512200,120,337339,57158,767,420818,809,297802,475557,12155,502356,19995,1865,259316,453395,315635,559,452557,155,420817,58,675,12444]}}, {"poster_path": {$ne: null}}]}},
#         {$sort: {"revenue": -1, "vote_average": -1}},
#         {"$limit": 3} 
#   ])
    pipeline = [
        {"$match": {"$and": [{"genres": {"$in": pipelineGenreKeywords}}, {"id": {"$nin": recommendedMovieList}}, {"poster_path": {"$ne": None}}]}},
        {"$sort": {"revenue": -1, "vote_average": -1}},
        {"$limit": 3}      
    ]

    aggregatedCollection = list(originalCollection.aggregate(pipeline= pipeline))

    processedCollection = []
    for movie in aggregatedCollection:
        processedMovie = {
            "id": movie["id"],
            "title": movie["title"],
            "revenue": movie["revenue"],
            "genres": movie["genres"],
            "poster_path": movie["poster_path"],
            "vote_average": movie["vote_average"]
        }
        processedCollection.append(processedMovie)

    return {"movies": processedCollection}

# 영화의 모든 장르들을 찾는 쿼리
# pipeline = [
#   { "$project": { "_id": 0, "genres": { "$split": ["$genres", ", "] } } },
#   { "$unwind": "$genres" },
#   { "$group": { "_id": "$genres" } }
# ]