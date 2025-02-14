// prilogenie1.h : main header file for the PRILOGENIE1 application
//

#if !defined(AFX_PRILOGENIE1_H__1A51C207_7C9D_46B6_9BE1_A923AF920562__INCLUDED_)
#define AFX_PRILOGENIE1_H__1A51C207_7C9D_46B6_9BE1_A923AF920562__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CPrilogenie1App:
// See prilogenie1.cpp for the implementation of this class
//

class CPrilogenie1App : public CWinApp
{
public:
	CPrilogenie1App();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPrilogenie1App)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CPrilogenie1App)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PRILOGENIE1_H__1A51C207_7C9D_46B6_9BE1_A923AF920562__INCLUDED_)
