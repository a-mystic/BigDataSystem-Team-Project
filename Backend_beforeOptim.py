import pymongo
from fastapi import FastAPI

# 서버실행코드 uvicorn Backend_beforeOptim:app --reload

# init
# db.collection.createIndex({ "revenue": -1, "vote_average": -1 })로 인덱스 생성
app = FastAPI()
client = pymongo.MongoClient('localhost', 27017)
originalCollection = client["Project"]["OriginalMoviesData"]

@app.get("/")
async def requestMovies(genres: str, recommendedMovieList: str):
    pipelineGenreKeywords = []
    for keyword in genres.split(','):
        pipelineGenreKeywords.append({"genres": {"$regex": keyword}})

    if recommendedMovieList == '':
        recommendedMovieList = []
    else:
        recommendedMovieList = list(map(int, recommendedMovieList.split(',')))
        
    pipeline = [
        {"$project": {"_id": 0, "id": 1, "title": 1, "revenue": 1, "genres": 1, "poster_path": 1, "vote_average": 1}},
        {"$match": {"$and": [{"$or": pipelineGenreKeywords}, {"id": {"$nin": recommendedMovieList}}, {"poster_path": {"$ne": None}}]}},
        {"$sort": {"revenue": -1, "vote_average": -1}},
        {"$limit": 3}      
    ]

    aggregatedCollection = list(originalCollection.aggregate(pipeline= pipeline))

    return {"movies": aggregatedCollection}
