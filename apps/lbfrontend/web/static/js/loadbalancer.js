import {Socket} from "phoenix"
import $        from "jquery"

let req         = document.querySelector("#request button")

export default class Loadbalancer {
  constructor() {
      this.setupDOM()
      this.channel = this.join_channel();
      this.setupEventHandlers(this.channel)
      //this.channel.push("get_status", {})

  }
  setupDOM() {
      this.title   = $(".title")
      this.desc = $(".desc")
      this.button = $('#request button')
  }

  join_channel() {
      let socket = new Socket("/socket", { logger: Loadbalancer.my_logger })
      socket.connect()
      let channel = socket.channel("loadbalancer:game")
      channel.join()
      return channel
  }

  req.addEventListener("click", event => {
  if(event.keyCode === 13){
    channel.push("new_msg", {body: req.value})

  }
})

  static my_logger(kind, msg, data) {
      console.log(`Socket: ${kind}: ${msg}`, data)
  }

}
