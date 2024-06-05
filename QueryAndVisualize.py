# 영화들이 가장많이 지원하는 언어 상위 20개
# import pymongo
# import matplotlib.pyplot as plt

# # MongoDB 연결
# client = pymongo.MongoClient('localhost', 27017)
# collection = client["Project"]["Movies"]

# pipeline = [
#    { "$project": { '_id': 0, 'languages': { "$split": ["$spoken_languages", ", "] } } },
#    { "$unwind": "$languages" },
#    { "$group": { '_id': "$languages", 'count': {"$sum": 1} } },
#    { "$sort": { 'count': -1 }},
#    { "$limit": 20}
# ]

# # 집계 실행 및 결과 저장
# result = list(collection.aggregate(pipeline=pipeline))

# # 결과를 시각화하기 위한 데이터 추출
# languages = [item['_id'] for item in result]
# counts = [item['count'] for item in result]

# # 막대 그래프 생성
# plt.figure(figsize=(10, 6))
# plt.bar(languages, counts, color='darkorange')
# plt.ylabel('Number of Movies')

# # x축 레이블 간격 조정
# plt.xticks(range(len(languages)), languages, rotation=90)

# plt.tight_layout()

# # 그래프 출력
# plt.show()

# 장르별 평균평점
# import pymongo
# import matplotlib.pyplot as plt

# # MongoDB 연결
# client = pymongo.MongoClient('localhost', 27017)
# collection = client["Project"]["Movies"]

# # 영화 장르별 평균평점 계산
# pipeline = [
#    { '$project': { '_id': 0, 'genres': { '$split': ["$genres", ", "] }, 'vote_average': 1 }},
#    {"$match": {"vote_average": {"$ne": 0}, "vote_average": {"$ne": None}}},
#    { '$unwind': "$genres" },
#    { '$group': { '_id': "$genres", 'voteAverage': {'$avg': "$vote_average"} }} 
#    ]

# # 집계 실행 및 결과 저장
# result = list(collection.aggregate(pipeline=pipeline))

# # 시각화
# genres = [r['_id'] for r in result]
# avg_scores = [r['voteAverage'] for r in result]

# # 전체 장르의 평균 계산
# total_average = sum(avg_scores) / len(avg_scores)

# # 선차트 생성
# plt.figure(figsize=(10, 6))
# plt.plot(genres, avg_scores, marker='o', linestyle='-', color='b', label='Genre Average')
# plt.axhline(y=total_average, color='r', linestyle='-', label='Total Average')
# plt.ylabel('Average Rating')
# plt.xticks(rotation= 90)
# plt.grid(True)
# plt.legend()
# plt.tight_layout()
# plt.show()

# 연도별 개봉영화 갯수 막대그래프
# import pymongo
# import matplotlib.pyplot as plt

# # MongoDB 연결
# client = pymongo.MongoClient('localhost', 27017)
# collection = client["Project"]["Movies"]

# pipeline = [
#     {"$match": {"release_date": {"$ne": None}, "status": "Released"}},
#     {'$group': {'_id': { '$year': { '$toDate': "$release_date" } },'count': { '$sum': 1 }}},
#     {'$sort': { '_id': 1 }}
# ]

# # 집계 실행 및 결과 저장
# result = list(collection.aggregate(pipeline=pipeline))

# # 결과를 시각화하기 위한 데이터 추출
# years = [int(item['_id']) for item in result]  # 연도값을 int로 변환
# counts = [item['count'] for item in result]

# # 막대 그래프 생성
# plt.figure(figsize=(10, 6))
# plt.bar(years, counts, color= 'deepskyblue')
# plt.ylabel('Number of Movies')
# plt.xticks(rotation=90)
# plt.tight_layout()
# plt.show()

# 전체 영화에서의 영화장르별 비율 파이차트
# import pymongo
# import matplotlib.pyplot as plt

# # MongoDB 연결
# client = pymongo.MongoClient('localhost', 27017)
# collection = client["Project"]["Movies"]

# pipeline =  [
#     { '$project': { '_id': 0, 'genres': { '$split': ["$genres", ", "] } } },
#     { '$unwind': "$genres" },
#     { '$group': { '_id': "$genres", 'count': {'$sum': 1} } }
# ]

# # 집계 실행 및 결과 저장
# result = list(collection.aggregate(pipeline=pipeline))

# # 결과로부터 라벨과 사이즈 추출
# labels = [entry['_id'] for entry in result]
# sizes = [entry['count'] for entry in result]

# # 파이차트 그리기
# plt.figure(figsize=(10, 6))
# plt.pie(sizes, labels= labels, autopct='%1.1f%%', startangle=140, textprops={'fontsize': 5}, colors=plt.cm.Set3.colors, pctdistance=0.8)
# plt.axis('equal')  # 원형 유지

# # 범례 그리기
# plt.legend(labels, loc="center left", bbox_to_anchor=(1, 0.5), fontsize='small')
# plt.show()

# 평점과 수익의 상관관계(산점도 그래프)
# import pymongo
# import pandas as pd
# import matplotlib.pyplot as plt

# # MongoDB에 연결
# client = pymongo.MongoClient("localhost", 27017)
# db = client["Project"]  # 여기에 데이터베이스 이름을 입력하세요
# collection = db["Movies"]  # 여기에 컬렉션 이름을 입력하세요

# pipeline = [
#     {"$project": {"_id": 0, "vote_average": 1, "revenue": 1}},
#     {"$match": {"vote_average": {"$ne": None, "$gt": 0},"revenue": {"$ne": None, "$gt": 0}}}
# ]

# # MongoDB에서 데이터 쿼리
# cursor = collection.aggregate(pipeline= pipeline)

# # 쿼리 결과를 DataFrame으로 변환
# df = pd.DataFrame(cursor)

# # 시각화를 위해 vote_average와 revenue 간의 관계를 산점도로 플로팅
# plt.figure(figsize=(10, 6))
# plt.scatter(df['vote_average'], df['revenue'], alpha=0.5)
# plt.title('Relationship between Vote Average and Revenue')
# plt.xlabel('Vote Average')
# plt.ylabel('Revenue')
# plt.grid(True)
# plt.show()

# 200분을기준으로나눈런타임박스플롯
import pymongo
import matplotlib.pyplot as plt

# MongoDB에 연결
client = pymongo.MongoClient("mongodb://localhost:27017/")
db = client["Project"]
collection = db["Movies"]

# MongoDB aggregation 파이프라인 작성: runtime 필드가 존재하고 0이나 None이 아닌 경우
pipeline = [
    {"$match": {"runtime": {"$exists": True, "$ne": 0, "$ne": None}}},
    {"$project": {"runtime": 1, "_id": 0}}
]

# aggregation 실행 및 결과 가져오기
runtimes = list(collection.aggregate(pipeline))

# runtime 값을 두 개의 리스트로 분류
runtimes_below_200 = [movie["runtime"] for movie in runtimes if movie["runtime"] <= 200]
runtimes_above_200 = [movie["runtime"] for movie in runtimes if movie["runtime"] > 200]

# # 박스플롯 그리기
# plt.figure(figsize=(12, 8))

# # 500 이하의 runtime에 대한 박스플롯
# plt.subplot(1, 2, 1)
# plt.boxplot(runtimes_below_200, vert= True)
# plt.title("Runtimes ≤ 200 minutes")
# plt.xlabel("Runtime (minutes)")

# # 500 초과의 runtime에 대한 박스플롯
# plt.subplot(1, 2, 2)
# plt.boxplot(runtimes_above_200, vert= True)
# plt.title("Runtimes > 200 minutes")
# plt.xlabel("Runtime (minutes)")

# plt.tight_layout()
# plt.show()


# 영화를 가장 많이 제작한 나라 상위 15개 (막대그래프)
# import pymongo
# import matplotlib.pyplot as plt

# # MongoDB에 연결
# client = pymongo.MongoClient("mongodb://localhost:27017/")
# db = client["Project"]
# collection = db["Movies"]

# # MongoDB aggregation 파이프라인 작성: 나라별 영화 개수를 집계
# pipeline = [
#     {"$match": {"production_countries": {"$exists": True, "$ne": ""}}},
#     {"$project": {"production_countries": {"$split": ["$production_countries", ", "]}}},
#     {"$unwind": "$production_countries"},
#     {"$group": {"_id": "$production_countries", "count": {"$sum": 1}}},
#     {"$sort": {"count": -1}},
#     {"$limit": 15}
# ]

# # aggregation 실행 및 결과 가져오기
# country_counts = list(collection.aggregate(pipeline))

# # 데이터 분리: 나라 이름과 영화 개수
# countries = [item["_id"] for item in country_counts]
# counts = [item["count"] for item in country_counts]

# # 막대그래프 그리기
# plt.figure(figsize=(14, 8))
# plt.barh(countries, counts, color='lightgreen')
# plt.xlabel('Number of Movies')
# plt.title('Top 15 Countries by Number of Movies Produced')
# plt.gca().invert_yaxis()  # 나라 이름이 많은 순서대로 표시되도록 y축 반전
# plt.show()

# 영화를 가장 많이 제작한 회사들 상위 10개(트리맵)
# import pymongo
# import matplotlib.pyplot as plt
# import squarify

# # MongoDB에 연결
# client = pymongo.MongoClient("mongodb://localhost:27017/")
# db = client["Project"]
# collection = db["Movies"]

# # MongoDB aggregation 파이프라인 작성: 제작사별 영화 개수를 집계
# pipeline = [
#     {"$match": {"production_companies": {"$exists": True, "$ne": ""}}},
#     {"$project": {"production_companies": {"$split": ["$production_companies", ", "]}}},
#     {"$unwind": "$production_companies"},
#     {"$group": {"_id": "$production_companies", "count": {"$sum": 1}}},
#     {"$sort": {"count": -1}},
#     {"$limit": 10}
# ]

# # aggregation 실행 및 결과 가져오기
# company_counts = list(collection.aggregate(pipeline))

# # 데이터 분리: 제작사 이름과 영화 개수
# companies = [item["_id"] for item in company_counts]
# counts = [item["count"] for item in company_counts]

# # 전체 영화 개수 계산
# total_movies = sum(counts)

# # 각 제작사의 영화 개수를 퍼센테이지로 변환
# percentages = [count / total_movies * 100 for count in counts]

# # 트리맵 생성
# plt.figure(figsize=(10, 6))
# colors = plt.cm.tab20.colors  # 20가지 색상 중에서 선택
# squarify.plot(sizes=counts, label=[f'{company}\n{percent:.2f}%' for company, percent in zip(companies, percentages)],
#               color=colors, alpha=0.7, text_kwargs={'fontsize': 10})
# plt.axis('off')  # 축 제거
# plt.title('Top 10 Production Companies by Number of Movies Produced')
# plt.show()

# 손익분기점(예산보다 수익이 큰 경우)을 넘긴 영화의 비율(파이차트)
# import pymongo
# import matplotlib.pyplot as plt

# # MongoDB에 연결
# client = pymongo.MongoClient("mongodb://localhost:27017/")
# db = client["Project"]
# collection = db["Movies"]

# # MongoDB aggregation 파이프라인 작성
# pipeline = [
#     {"$match": {"budget": {"$exists": True, "$ne": 0}, "revenue": {"$exists": True, "$ne": 0}}},
#     {"$project": {"_id": 0, "budget": 1, "revenue": 1}},
#     {"$addFields": {"profit": {"$gt": ["$revenue", "$budget"]}}}
# ]

# # aggregation 실행 및 결과 가져오기
# movies = list(collection.aggregate(pipeline))

# # 손익분기점을 넘긴 영화와 넘지 못한 영화 계산
# total_movies = len(movies)
# profitable_movies = sum(movie["profit"] for movie in movies)
# non_profitable_movies = total_movies - profitable_movies

# # 비율 계산
# labels = ['Profitable Movies', 'Non-profitable Movies']
# sizes = [profitable_movies, non_profitable_movies]
# colors = ['lightgreen', 'lightcoral']
# explode = (0.1, 0)  # 첫 번째 조각 분리

# # 파이차트 그리기
# plt.figure(figsize=(8, 8))
# plt.pie(sizes, explode=explode, labels=labels, colors=colors, autopct='%1.1f%%', shadow=True, startangle=140)
# plt.title('Percentage of Profitable Movies')
# plt.show()


#######################    Query    #######################




# 연도별로 영화가 몇개씩 개봉했는지 찾는 쿼리(막대차트)
# [
#     {'$group': {'_id': { '$year': { '$toDate': "$release_date" } },'count': { '$sum': 1 }}},
#     {'$sort': { '_id': 1 }}
# ]

# 특정 장르에 속한 영화들의 갯수를 세는 쿼리(파이차트)
# [
#    { '$project': { '_id': 0, 'genres': { '$split': ["$genres", ", "] } } },
#    { '$unwind': "$genres" },
#    { '$group': { '_id': "$genres", 'count': {'$sum': 1} } }
#  ]

# 영화장르별로 평점평균이 어떤지 보는 쿼리(선차트)
# [
#    { '$project': { '_id': 0, 'genres': { '$split': ["$genres", ", "] }, 'vote_average': 1 }},
#    { '$unwind': "$genres" },
#    { '$group': { '_id': "$genres", 'voteAverage': {'$avg': "$vote_average"} }}
#  ]

# 영화들이 지원하는 언어들중 상위20개를 알아보는 쿼리
# pipeline = [
#    { "$project": { '_id': 0, 'languages': { "$split": ["$spoken_languages", ", "] } } },
#    { "$unwind": "$languages" },
#    { "$group": { '_id': "$languages", 'count': {"$sum": 1} } },
#    { "$sort": { 'count': -1 }},
#    { "$limit": 20}
# ]

# 평점과 수익에 대해 불러오는 쿼리 
# pipeline = [
#     {"$project": {"_id": 0, "vote_average": 1, "revenue": 1}},
#     {"$match": {"vote_average": {"$ne": None, "$gt": 0},"revenue": {"$ne": None, "$gt": 0}}}
# ]


