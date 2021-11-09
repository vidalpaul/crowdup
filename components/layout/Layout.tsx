import { Grid } from 'carbon-components-react';
import React from 'react';
import Footer from './Footer';
import MainHeader from './MainHeader';

const Layout: React.FC = (props) => {
   return (
      <Grid>
         <MainHeader />
         {props.children}
         <Footer />
      </Grid>
   );
};

export default Layout;
