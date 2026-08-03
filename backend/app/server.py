from app.main import app
from app.youtube_case_study import router as youtube_case_study_router

app.include_router(youtube_case_study_router)
