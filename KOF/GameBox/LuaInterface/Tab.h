    class CTab : public CUserControl
    {
    public:

	static CTab* create(enumLayoutDirection _value, const CCSize &_cellSize);
        
        void addTab( CTabPage *pTabPage, CContainer *pTabContainer );
        void removeTab( CTabPage *pTabPage );
        void removeTabByIndex( unsigned int uIndex );
        void onTabChange( CTabPage *pTabPage );
        
        CLayout *getLayout();
	void setSelectedTabIndex(unsigned int uIndex);
    };