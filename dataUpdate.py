from pymongo import MongoClient

# MongoDB에 접속
client = MongoClient('mongodb://localhost:27017/')
db = client['Project']  # 데이터베이스 이름 지정
collection = db['Movies']  # 컬렉션 이름 지정

# 모든 문서 불러오기
documents = collection.find()

# 모든 document들을 embedded document 형태로 변경하는 코드입니다.
for doc in documents:
    # genres 필드가 존재하는지 확인
    if 'genres' in doc.keys():
        # genres 필드를 쉼표로 분할하여 리스트로 변환
        genres_list = doc['genres'].split(', ')
        
        # 데이터 업데이트
        collection.update_one(
            {"_id": doc["_id"]},
            {"$set": {"genres": genres_list}}
        )

# 이후 위의 코드를 주석처리하고 이 코드를 실행해주시면 됩니다. 같이 실행하면 왜그런지 모르겠는데 아래 코드는 실행이 안되네요.. document들 중 genres 필드가 없는 document들을 제거하는 코드입니다.
# for doc in documents:
#     if 'genres' not in doc.keys():
#         collection.delete_one({"_id": doc["_id"]})