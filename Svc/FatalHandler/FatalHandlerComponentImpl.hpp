// ====================================================================== 
// \title  FatalHandlerImpl.hpp
// \author tcanham
// \brief  hpp file for FatalHandler component implementation class
//
// \copyright
// Copyright 2009-2015, by the California Institute of Technology.
// ALL RIGHTS RESERVED.  United States Government Sponsorship
// acknowledged. Any commercial use must be negotiated with the Office
// of Technology Transfer at the California Institute of Technology.
// 
// This software may be subject to U.S. export control laws and
// regulations.  By accepting this document, the user agrees to comply
// with all U.S. export laws and regulations.  User has the
// responsibility to obtain export licenses, or other export authority
// as may be required before exporting such information to foreign
// countries or providing access to foreign persons.
// ====================================================================== 

#ifndef FatalHandler_HPP
#define FatalHandler_HPP

#include "Svc/FatalHandler/FatalHandlerComponentAc.hpp"

namespace Svc {

  class FatalHandlerComponentImpl :
    public FatalHandlerComponentBase
  {

    public:

      // ----------------------------------------------------------------------
      // Construction, initialization, and destruction
      // ----------------------------------------------------------------------

      //! Construct object FatalHandler
      //!
      FatalHandlerComponentImpl(
#if FW_OBJECT_NAMES == 1
          const char *const compName /*!< The component name*/
#else
          void
#endif
      );

      //! Initialize object FatalHandler
      //!
      void init(
          const NATIVE_INT_TYPE instance = 0 /*!< The instance number*/
      );

      //! Destroy object FatalHandler
      //!
      ~FatalHandlerComponentImpl(void);

    PRIVATE:

      // ----------------------------------------------------------------------
      // Handler implementations for user-defined typed input ports
      // ----------------------------------------------------------------------

      //! Handler implementation for FatalReceive
      //!
      void FatalReceive_handler(
          const NATIVE_INT_TYPE portNum, /*!< The port number*/
          FwEventIdType Id /*!< The ID of the FATAL event*/
      );


    };

} // end namespace Svc

#endif
