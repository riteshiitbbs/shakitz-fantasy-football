var CommentBoard = React.createClass({

  getInitialState: function(){
    return {
      comments: []
    };
  },

  loadCommentsFromServer: function() {
    $.get(this.props.url, function(result){
      var comments = result;
      if(this.isMounted()){
        this.setState({
          comments: comments
        });
      }
    }.bind(this));
  },

  scrollToBottom: function() {
	var board = $('#comment-board');
	board.scrollTop(board.prop("scrollHeight"));
  },
  
  componentDidMount: function() {
    this.loadCommentsFromServer();
  	this.scrollToBottom();
    setInterval(this.loadCommentsFromServer, this.props.pollInterval);
  },

  render: function() {
    return (
      <div id="comment-board">
        {this.state.comments.map(function(commentData){
          return <Comment key={commentData.id} data={commentData} />;
        })}
        <CommentSubmit url={this.props.post} user_id={this.props.user_id}/>
      </div>
    );
  }
});
