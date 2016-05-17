    class CApplication
    {
    public:
        static CApplication *sharedApplication();
	const char *getBundleVersion();
        const char *getStartupPath();
        const char *getResourcePath();
    };
