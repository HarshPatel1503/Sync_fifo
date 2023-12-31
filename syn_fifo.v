    module syn_fifo (clk,rst, wr_cs, rd_cs , data_in, rd_en, wr_en, data_out , empty, full);    
   
   // Port Declarations
   input clk ;
   input rst ;
   input wr_cs ;
   input rd_cs ;
   input rd_en ;
   input wr_en ;
   input [DATA_WIDTH-1:0] data_in ;
   output full ;
   output empty ;
   output [DATA_WIDTH-1:0] data_out ;
   
   //-----------Internal variables-------------------
   reg [ADDR_WIDTH-1:0] wr_pointer;
   reg [ADDR_WIDTH-1:0] rd_pointer;
   reg [ADDR_WIDTH :0] status_cnt;
   reg [DATA_WIDTH-1:0] data_out ;
   wire [DATA_WIDTH-1:0] data_ram ;
	
	// FIFO constants
   parameter DATA_WIDTH = 8;
   parameter ADDR_WIDTH = 8;
   parameter RAM_DEPTH = (1 << ADDR_WIDTH);
   
   //-----------Variable assignments---------------
   assign full = (status_cnt == (RAM_DEPTH-1));
   assign empty = (status_cnt == 0);
   
   //-----------Code Start---------------------------
   always @ (posedge clk or posedge rst)
   begin : WRITE_POINTER
     if (rst) begin
       wr_pointer <= 0;
     end else if (wr_cs && wr_en ) begin
       wr_pointer <= wr_pointer + 1;
     end
   end
   
   always @ (posedge clk or posedge rst)
   begin : READ_POINTER
     if (rst) begin
       rd_pointer <= 0;
     end else if (rd_cs && rd_en ) begin
       rd_pointer <= rd_pointer + 1;
     end
   end
   
   always  @ (posedge clk or posedge rst)
   begin : READ_DATA
     if (rst) begin
       data_out <= 0;
     end else if (rd_cs && rd_en ) begin
       data_out <= data_ram;
     end
   end
   
   always @ (posedge clk or posedge rst)
   begin : STATUS_COUNTER
     if (rst) begin
       status_cnt <= 0;
     // Read but no write.
     end 
	  else if ((rd_cs && rd_en) && (wr_cs && wr_en) && (status_cnt!= 0)) 
	  begin
       status_cnt <= status_cnt - 1;
     // Write but no read.
     end 
	  else if ((wr_cs && wr_en) &&  (rd_cs && rd_en) 
                  && (status_cnt!= RAM_DEPTH)) begin
       status_cnt <= status_cnt + 1;
     end
   end 
      
   
  
  endmodule
  