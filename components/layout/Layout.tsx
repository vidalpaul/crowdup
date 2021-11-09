import React from 'react';
import Footer from './Footer';
import MainHeader from './MainHeader';

const Layout: React.FC = (props) => {
   return (
      <>
         <MainHeader />
         {props.children}
         <Footer />
      </>
   );
};

export default Layout;
