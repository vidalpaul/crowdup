import {
   Button,
   Grid,
   Header,
   HeaderContainer,
   HeaderName,
   HeaderGlobalAction,
   HeaderGlobalBar,
   HeaderNavigation,
   HeaderMenu,
   HeaderMenuItem,
   Search,
} from 'carbon-components-react';
import Search20 from '@carbon/icons-react/lib/search/20';
import Notification20 from '@carbon/icons-react/lib/notification/20';
import AppSwitcher20 from '@carbon/icons-react/lib/app-switcher/20';

const MainHeader = () => {
   return (
      <>
         <Grid className='bx--grid--full-width'>
            <div className='container'>
               <Header aria-label='CrowdUp Platform Name'>
                  <HeaderName href='#' prefix=''>
                     CrowdUp
                  </HeaderName>
                  <HeaderNavigation aria-label='IBM [Platform]'>
                     <HeaderMenuItem href='#'>Featured</HeaderMenuItem>
                     <HeaderMenuItem href='#'>All Campaigns</HeaderMenuItem>
                     <HeaderMenuItem href='#'>+ Create Campaign</HeaderMenuItem>
                     <HeaderMenu
                        aria-label='Link 4'
                        menuLinkName='My Campaigns'
                     >
                        <HeaderMenuItem href='#'>Sub-link 1</HeaderMenuItem>
                        <HeaderMenuItem href='#'>Sub-link 2</HeaderMenuItem>
                     </HeaderMenu>
                  </HeaderNavigation>
                  <HeaderGlobalBar>
                     <HeaderGlobalAction aria-label='Search' onClick={() => {}}>
                        <Search20 />
                     </HeaderGlobalAction>
                     <HeaderGlobalAction
                        aria-label='Notifications'
                        onClick={() => {}}
                     >
                        <Notification20 />
                     </HeaderGlobalAction>
                     <HeaderGlobalAction
                        aria-label='App Switcher'
                        onClick={() => {}}
                     >
                        <AppSwitcher20 />
                     </HeaderGlobalAction>
                  </HeaderGlobalBar>
               </Header>
            </div>
            <div className='container'>
               <h1>
                  CrowUp is the ultimate crowsourcing platform, powered by
                  Ethereum
               </h1>
            </div>
         </Grid>
      </>
   );
};

export default MainHeader;
