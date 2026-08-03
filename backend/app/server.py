from .main import app
from .youtube_case_study import router as youtube_case_study_router

app.include_router(youtube_case_study_router)
