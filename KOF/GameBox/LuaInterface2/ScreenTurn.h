    class CScreenTurn : public CUserControl
    {
    public:

        static CScreenTurn *create(CContainer *pContainer);
        
        unsigned int getCurrentPage();
        
        void setCurrentPage(unsigned int uPage);

        void goPreviousPage();
        
        void goNextPage();
        
    };