// to review completely

import React, { Component } from 'react';
import { Button, Message, Table } from 'semantic-ui-react';
import web3 from '../ethereum/web3';
import Campaign from '../ethereum/campaign';

class RequestRow extends Component {
   state = { approveLoading: false, finalizeLoading: false, errorMessage: '' };
   onApprove = async (event) => {
      const campaign = Campaign(this.props.address);
      const accounts = await web3.eth.getAccounts();
      await campaign.methods
         .approveRequest(this.props.id)
         .send({ from: accounts[0] });
   };
   onFinalize = async (event) => {
      const campaign = Campaign(this.props.address);
      const accounts = await web3.eth.getAccounts();
      await campaign.methods
         .finalizeRequest(this.props.id)
         .send({ from: accounts[0] });
   };

   render() {
      const { Row, Cell } = Table;
      const { id, request, approversCount } = this.props;
      const readyToFinalize = request.approvalCount > approversCount / 2;
      return (
         <Row
            disabled={request.complete}
            positive={readyToFinalize && !request.complete}
         >
            <Cell>{id}</Cell>
            <Cell>{request.description}</Cell>
            <Cell>{web3.utils.fromWei(request.value, 'ether')}</Cell>
            <Cell>{request.recipient}</Cell>
            <Cell>{`${request.approvalCount}/${approversCount}`}</Cell>
            <Cell>
               {request.complete ? null : (
                  <Button
                     color='green'
                     basic
                     onClick={this.onApprove}
                     loading={this.state.approveLoading}
                  >
                     Approve
                  </Button>
               )}
            </Cell>
            <Cell>
               {request.complete ? null : (
                  <Button
                     basic
                     onClick={this.onFinalize}
                     loading={this.state.finalizeLoading}
                  >
                     Finalize
                  </Button>
               )}
            </Cell>
         </Row>
      );
   }
}

export default RequestRow;
