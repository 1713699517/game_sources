    class CContainer : public CUserControl
    {
    public:
        static CContainer *create();

        void setIsForm(bool bIsForm);
        bool getIsForm();
    };
